from pathlib import Path

PROJECTS_DIR: str = '/home/ring_r/src'

if __name__ == '__main__':
    for path in Path(PROJECTS_DIR).glob('*/'):
        print(f'{path.name}:')
        readme_path: Path = path / 'README.md'
        if readme_path.exists():
            readme_path: Path = path / 'README.md'
            with open(readme_path) as readme_file:
                for _ in range(2):
                    p: str = readme_file.readline()
                    print(p)
        print('-'*10)
