# script to clone all repos owned by an account, excluding forks
# I plan to use this in a future cold storage project
#
# requires github personal access token with repo access

import os
import traceback
from dotenv import load_dotenv
from github import Github
from git import Repo

def get_repo_list(gh: Github, user: str) -> list:
    return [r.name for r in gh.get_user().get_repos() if r.owner.login == user and not r.fork]

def backup_repos(gh: Github, user: str, pat: str, repos: list, backup_path: str = '.'):
    if not os.path.exists(backup_path):
        os.makedirs(backup_path)

    for i, repo in enumerate(repos):
        clone_url = f'https://{pat}@github.com/{user}/{repo}.git'
        clone_to = os.path.join(backup_path, repo)

        if os.path.exists(clone_to):
            print(f'Pulling {repo} [{i+1} of {len(repos)}]')
            r = Repo(clone_to)
            r.remote('origin').fetch()
            r.remote('origin').pull()
        else:
            print(f'Cloning {repo} [{i+1} of {len(repos)}]')
            Repo.clone_from(clone_url, clone_to)

def main():
    load_dotenv(dotenv_path=os.path.abspath('.env'))
    user = os.getenv('GITHUB_USER')
    pat = os.getenv('GITHUB_PAT')

    try:
        gh = Github(pat)
        repos = get_repo_list(gh, user)
        
        exclude = os.getenv('EXCLUDE_REPOS')
        if ',' in exclude:
            exclude = exclude.split(',')
        else:
            exclude = [exclude]

        print(f'excluding {len(exclude)} repo(s) of {len(repos)}')
        repos = [r for r in repos if r not in exclude]

        backup_repos(gh, user, pat, repos, os.getenv('BACKUP_PATH'))
    except KeyboardInterrupt:
        print('Exited early')
    except:
        print('Unexpected error occurred!')
        traceback.print_exc()

if __name__ == '__main__':
    main()
