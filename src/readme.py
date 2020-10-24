import readme_template


def get(cleaners):
    menu = "\n".join([f"- {cleaner}" for cleaner in cleaners])
    return readme_template.get().format(menu=menu)
