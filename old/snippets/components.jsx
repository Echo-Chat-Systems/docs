import { Button, CodeBlock, Expandable } from "@mintlify/components";

export const Schema = ({ children, path }) => {
    const [schema, setSchema] = useState(0)

    const get = () => fetch("https://static.echo-chat.au/schemas" + path, )
        .then(response => response.text())
        .then(data => {
            console.log(data)
            setSchema(data)
        })

    return (
        <Expandable title="Schema">
            <CodeBlock>
                {schema}
            </CodeBlock>
            <Button onClick={get}>Get Schema</Button>
        </Expandable>
    )
}

export const Tester = () => {
    return (<p> Test deez nutz! </p>)
}