public class KeyValuePair{
    public string key {get; set;}
    public object value {get; set;}
    
    public KeyValuePair(string k, object v){
        this.key = k;
        this.value = v;
    }
}