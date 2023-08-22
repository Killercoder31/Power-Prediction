import pandas as pd
from flask import Flask, jsonify, request
from flask_restful import Api
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split

df = pd.read_excel(r"./server/Ml_data_V5.xlsx")
df["Electrolyte"].replace({"NaOH": 0, "KOH": 1}, inplace=True)

x = df.drop("Power density_mW/cm2", axis=1)
y = df["Power density_mW/cm2"]

x_train, x_test, y_train, y_test = train_test_split(
    x, y, test_size=0.2, random_state=10
)

RF_model = RandomForestRegressor()
RF_model.fit(x_train, y_train)


y_pred_RF = RF_model.predict(x_test)


# creating the flask app
app = Flask(__name__)
# creating an API object
api = Api(app)
app.config["MAX_CONTENT_PATH"] = 1024 * 1024 * 10


@app.route("/predict", methods=["GET"])
def hello_world():
    electrolyte = request.args.get("electrolyte", None)
    electrolyteConcentration = request.args.get("electrolyteConcentration", None)
    current = request.args.get("current", None)
    voltage = request.args.get("voltage", None)
    # print(electrolyte)
    # print(electrolyteConcentration)
    return jsonify(
        {
            "prediction": RF_model.predict(
                pd.DataFrame(
                    {
                        "Electrolyte": [electrolyte],
                        "Electrolyte\ncocentration": [electrolyteConcentration],
                        "Voltage_V": [voltage],
                        "Current density_mA/cm2": [current],
                    }
                )
            )[0]
        }
    )



if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True, threaded=True)
