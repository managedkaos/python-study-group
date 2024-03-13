import json


def get_notebook_instance_name(file_path=None):
    """
    Read metadata from JSON file

    Parameters:
    - file_path (str): Path to the JSON file. Defaults to "/opt/ml/metadata/resource-metadata.json".

    Returns:
    - dict: The loaded metadata.

    Raises:
    - FileNotFoundError: If the file does not exist.
    - ValueError: If the file content is not valid JSON.
    - RuntimeError: For other types of errors.
    """
    if file_path is None:
        file_path = "/opt/ml/metadata/resource-metadata.json"

    # Try to open the file and load its content
    try:
        with open(file_path, "r") as file:
            metadata = json.load(file)

    # Stop running if the file is not found
    except FileNotFoundError:
        raise FileNotFoundError(f"The file at {file_path} was not found.")

    # Stop running if the file is not JSON
    except json.JSONDecodeError:
        raise ValueError("Failed to decode JSON from the file.")

    # Stop running if any other errors are encountered
    except Exception as e:
        raise RuntimeError(f"An unexpected error occurred: {str(e)}")

    # Return the ResourceName value
    return metadata["ResourceName"]
