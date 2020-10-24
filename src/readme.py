import cleaners
import readme_template


def get():
    menu = "\n".join([f"- {cleaner}" for cleaner in cleaners.get()])
    return readme_template.get().format(menu=menu)
