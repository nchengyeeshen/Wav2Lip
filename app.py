import os
import subprocess

from flask import (
    Flask,
    flash,
    redirect,
    render_template,
    request,
    send_from_directory,
    url_for,
)
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = "/tmp/uploads"

app = Flask(__name__)
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
os.makedirs(app.config["UPLOAD_FOLDER"], exist_ok=True)


@app.route("/uploads/<filename>")
def uploaded_file(filename):
    return send_from_directory(app.config["UPLOAD_FOLDER"], filename)


@app.route("/", methods=["GET", "POST"])
def upload_file():
    if request.method == "POST":
        if "video" not in request.files or "audio" not in request.files:
            flash("No file part")
            return redirect(request.url)

        video = request.files["video"]
        audio = request.files["audio"]

        if video.filename == "" or audio.filename == "":
            flash("No selected file")
            return redirect(request.url)

        if video and audio:
            video_path = os.path.join(
                app.config["UPLOAD_FOLDER"], secure_filename(video.filename)
            )
            audio_path = os.path.join(
                app.config["UPLOAD_FOLDER"], secure_filename(audio.filename)
            )

            video.save(video_path)
            audio.save(audio_path)

            status = subprocess.run(
                [
                    "python",
                    "inference.py",
                    "--checkpoint_path",
                    "checkpoints/wav2lip.pth",
                    "--face",
                    video_path,
                    "--audio",
                    audio_path,
                    "--outfile",
                    os.path.join(app.config["UPLOAD_FOLDER"], "results.mp4"),
                ]
            )

            if status.returncode != 0:
                flash("Something went wrong. Please check the selected video or audio file.")
                return redirect(request.url)

            return redirect(url_for("uploaded_file", filename="results.mp4"))

    return render_template("index.html")


if __name__ == "__main__":
    app.debug = True
    app.secret_key = "super duper secret"
    app.run()
