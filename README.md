# QPOLL

QPOLL is a versatile voting application developed using Flutter for mobile platforms. It leverages Firebase for database operations (CRUD) and Supabase for image storage and public link generation. The application supports both private and public voting, allowing candidates to register for public polls. It features an intuitive user interface and engaging animations for an enhanced user experience.

## Features

- **Private and Public Voting**: Create and participate in both private and public polls.
- **Candidate Registration**: Candidates can register themselves for public voting events.
- **User-Friendly Interface**: Easy-to-navigate UI with attractive animations.
- **Image Storage**: Utilizes Supabase for storing images and generating public links.

## Installation

To run QPOLL locally, follow these steps:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/mzrox/QPOLL.git
   ```
2. **Navigate to the Project Directory**:
   ```bash
   cd QPOLL
   ```
3. **Install Dependencies**:
   Ensure you have Flutter installed. Then, run:
   ```bash
   flutter pub get
   ```
4. **Configure Firebase**:
   - Set up a Firebase project.
   - Replace the existing `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) files in the project with your own from the Firebase console.
5. **Configure Supabase**:
   - Set up a Supabase project.
   - Update the Supabase configuration in the project with your Supabase URL and public API key.

6. **Run the Application**:
   ```bash
   flutter run
   ```

## Usage

- **Creating a Poll**: Navigate to the 'Create Poll' section, enter the poll details, and publish.
- **Participating in a Poll**: Browse available polls, select one, and cast your vote.
- **Candidate Registration**: For public polls, candidates can register by providing necessary details and uploading relevant images.

## Contributing

We welcome contributions to enhance QPOLL. To contribute:

1. Fork the repository.
2. Create a new branch:
   ```bash
   git checkout -b feature/YourFeatureName
   ```
3. Make your changes and commit them:
   ```bash
   git commit -m 'Add some feature'
   ```
4. Push to the branch:
   ```bash
   git push origin feature/YourFeatureName
   ```
5. Open a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any inquiries or feedback, please contact [mzrox](https://github.com/mzrox).

---

*Note: Ensure that you have the necessary permissions and API keys configured for Firebase and Supabase services to utilize all features of the application.* 
