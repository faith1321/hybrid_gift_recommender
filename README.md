# Hybrid Gifting App with Product Recommender System

A Flutter application that recommends products based on user ratings and product similarities.

- [About the Project](#about-the-project)
  - [Built With](#built-with)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [License](#license)
- [Contact](#contact)

## About the Project

This project was done for my Final Year Dissertation during my Bachelor's degree.
### Built With

- [Flutter](https://flutter.dev)
- [Python](https://www.python.org/)

### Details
- Development of the frontend was done with Flutter, which allows seamless cross-platform deployment.
- Firebase was used as the main backend component, utilizing their Cloud Firestore and Authentication services.
- The recommender system was built using Python and TensorFlow, converted into a TFLite model.
---
## Getting Started

### Prerequisites

**Flutter**

Ensure you have the required Flutter SDK on your machine by running:
```
flutter
```

**Python**

Installation instructions can be found [here](https://docs.flutter.dev/get-started/install) on flutter.dev.

Python related dependencies can be installed by running:

```python
pip install -r requirements.txt
```
---
### Installation

Clone the repo:

```sh
git clone https://github.com/faith1321/hybrid_gift.git
```
---
## Usage

There are 2 segments in this project:

1. Hybrid Application

    - [lib/](lib/): contains files that implement the base framework of the application. [`main.dart`](lib/main.dart) is the main file to be run and is the entry point into the application.
    - [lib/src/](lib/src/): contains [`pages.dart`](lib/src/pages.dart) that defines and manages the logic of page navigation.
    - [lib/src/screens/](lib/src/screens/): contains the . It also contains the folders with the files for each display screen: the Home Page, the Order Page and the User Page.
    - [lib/utils/](lib/utils/): contains utility items used across the whole project:
      - [Camera Access](lib/utils/camera.dart)
      - [Constants](lib/utils/constants.dart)
      - [Digital Templates](lib/utils/digital_templates.dart)
      - [File Upload](lib/utils/file_upload.dart)
      - [Products](lib/utils/products.dart)
      - [Search Bar](lib/utils/search_bar.dart)
      - [Widgets](lib/utils/widgets.dart)

2. Recommender System
    - [lib/recommender_system/](lib/recommender_system/): contains the recommender system Python scripts. [`recommender.py`](lib/recommender_system/recommender.py) is the main file that generates the model and converts it into a TensorFlow SavedModel and then TFLite model, storing it in [assets/](assets/).
      - Run [`results_test.py`](lib/recommender_system/results_test.py) to start testing the model.

<!-- ### 1. [collecting_data](collecting_data/)

There are two stages to collecting the required dataset.

#### 1a. [scraping_midi](collecting_data/1_scraping_midi)

Different scripts download MIDI files from various sources into [a bin directory](data/bin/). Manually downloaded MIDI files can be manually added in here as well.

#### 1b. [building_dataset](collecting_data/2_building_dataset)

1. `create_db.py` goes through the bin directory and builds a database containing the ids of the samples.
2. From here, I have manually added the theme labels as columns, as well as metadata columns such as `duplicate`.
3. Then, the samples are slowly labelled, marking songs that I've looked through with a 1 in the `recognizable` column if I have labelled them, and 0 if not (This means that if that field is empty/null, it has not been identified yet).
4. `process_db.py` converts all 'p's in the database into '1's.[^1]
5. `db_stats.py` is a convenience script that returns some statistics about the label dataset so far.

[^1]: This is because I have sped up the hand-labelling process by marking fields with '0' or 'p', since they are closeby on the keyboard. The script later turns the 'p's into '1's.

### 2. [calculating_dataset](calculating_dataset/)

1. `generate_jsymbolic_config.py` builds a configuration script based on the MIDI files found in the bin directory.
2. Run `jSymbolic` with [themeConfigFile.txt](calculating_dataset/themeConfigFile.txt) as the configuration script.
3. Finally, run `clean_db.py` to clean up the database for use.

These three steps can (and should) be automatically executed.

Here is a script file that I've used — modify it to point to your jSybolic2.jar.

```sh
python3 calculating_dataset/generate_jsymbolic_config.py

java -Xmx3072m -jar [PATH_TO_YOUR_JSYMBOLIC]/jSymbolic2.jar -configrun calculating_dataset/themeConfigFile.txt

python3 calculating_dataset/clean_db.py
```

### 3. [building_model](building_model)

From here, it is mostly automated.

`model.py` is the main script to run. You should never need to fiddle with it because the parameters can all be configured with `config.py`.

## License

<!-- Distributed under the MIT License. See `LICENSE` for more information. -->

## Contact

20218985 Faith New Xin Yue hcyfn1
