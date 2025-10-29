// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ChainShelf {

    // 🧩 Structure to represent a Book
    struct Book {
        uint id;
        string title;
        bool isCheckedOut;
        address borrower;
    }

    // 👑 Owner of the system (library admin)
    address public owner;

    // 📘 Mapping to store books (bookId => Book)
    mapping(uint => Book) public books;

    // 🔢 Count of all books
    uint public totalBooks;

    // 📢 Events for transparency (logged on blockchain)
    event BookAdded(uint id, string title);
    event BookCheckedOut(uint id, address borrower);
    event BookReturned(uint id, address borrower);

    // 🏗 Constructor — sets the contract deployer as owner
    constructor() {
        owner = msg.sender;
    }

    // ⚙️ Modifier to restrict admin-only actions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can do this");
        _;
    }

    // 📗 Function 1: Add a new book (only owner can)
    function addBook(string memory _title) public onlyOwner {
        totalBooks++;
        books[totalBooks] = Book(totalBooks, _title, false, address(0));
        emit BookAdded(totalBooks, _title);
    }

    // 📙 Function 2: Checkout a book
    function checkoutBook(uint _bookId) public {
        Book storage book = books[_bookId];
        require(book.id != 0, "Book does not exist");
        require(!book.isCheckedOut, "Book already checked out");

        book.isCheckedOut = true;
        book.borrower = msg.sender;

        emit BookCheckedOut(_bookId, msg.sender);
    }

    // 📘 Function 3: Return a book
    function returnBook(uint _bookId) public {
        Book storage book = books[_bookId];
        require(book.id != 0, "Book does not exist");
        require(book.isCheckedOut, "Book is not checked out");
        require(book.borrower == msg.sender, "You are not the borrower");

        book.isCheckedOut = false;
        book.borrower = address(0);

        emit BookReturned(_bookId, msg.sender);
    }

    // 📄 Function 4: View book details
    function getBook(uint _bookId) public view returns (Book memory) {
        return books[_bookId];
    }
}

