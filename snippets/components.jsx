export function Schema({ path }) {
    let contents;

    // Get file contents
    fetch("https://static.echo-chat.au/schemas" + path)
        .then(response => response.json())
        .then(json => contents = json)

    return (
        <p>
            ballin
            <code>
                {contents}
            </code>
        </p>

    )
}

