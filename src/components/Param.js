import param from "./styles.param.css";

export const Param = ({ name, type, required = false, children }) => {
    return (
        <div className="param">
            <div className="info">
                <span className="name">{name}</span>
                <code className="info-item type">{type}</code>
                {required && (
                    <code className="info-item required">
                        required
                    </code>
                )}
            </div>
            {children && (
                <div className="description">
                    {children}
                </div>
            )}
            <hr></hr>
        </div>
    )
}