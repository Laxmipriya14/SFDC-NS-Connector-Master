/**
 * @description       : This class provides methods to generate signature and set HTTP header parameter with all the OAUTH1.0 parameters
 *                      parameters : realm,consumer key,token,signature method,timestamp,nonce,version,signature      
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-02-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public without sharing class NSOAUTH1Service {
    private NS_Sandboxes__c sandboxDet;
    /**
    * @description : 
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-01-2024 
    * @param sandboxDet 
    **/
    public NSOAUTH1Service(NS_Sandboxes__c sandboxDet){
        this.sandboxDet = sandboxDet;
    }

    /**
    * @description : set HTTP Authorization paramete in header   
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-01-2024 
    * @param httpReq 
    **/
    public void setOAUTH1Authorization(HttpRequest httpReq){
        Oauth1Wrapper configDetails = new Oauth1Wrapper(this.sandboxDet);
        String signature = getSignature(configDetails);
        String authHeader = getAuthHeader(configDetails,signature);
        httpReq.setHeader('Authorization',authHeader);
    } 

    /**
    * @description : prepare string of all the required parameters for authorization with signature to add it the HTTP authoraization header
                     parameters : realm,consumer key,token,signature method,timestamp,nonce,version,signature
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-01-2024 
    * @param authDetails 
    * @param signature 
    * @return String 
                :returns concatenated string of all authorization parameters
    **/
    private String getAuthHeader(Oauth1Wrapper authDetails,String signature){
        String authHeader = 'OAuth ';
        authHeader += 'realm="'+authDetails.realm+'",';
        authHeader += 'oauth_consumer_key="'+authDetails.customerKey+'",';
        authHeader += 'oauth_token="'+authDetails.token+'",';
        authHeader += 'oauth_signature_method="'+authDetails.signMethod+'",';
        authHeader += 'oauth_timestamp="'+authDetails.timeStamp+'",';
        authHeader += 'oauth_nonce="'+authDetails.nonce+'",';
        authHeader += 'oauth_version="1.0",';
        authHeader += 'oauth_signature="'+signature+'"';
        return authHeader;
    }  
    /**
    * @description : Component in the OAUTH 1 protocol to secure API request. It is generated using OAUTH parameters
                     Consumer Key, Access Token, OAUTH Nonce and Timestamp by applying hashing (HMAC-SHA256) on the signature.    
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 03-01-2024 
    * @param authDetails 
    * @return String 
                :returns signature by combining all the parameters in the 
    **/
    private String getSignature(Oauth1Wrapper authDetails){
        String encodedString = EncodingUtil.URLENCODE(authDetails.endPointUrl,'UTF-8');
        String signUrl = 'deploy=1&oauth_consumer_key='+authDetails.customerKey+'&oauth_nonce='+authDetails.nonce+'&oauth_signature_method='+authDetails.signMethod+'&oauth_timestamp='+authDetails.timeStamp+'&oauth_token='+authDetails.token+'&oauth_version=1.0&'+ authDetails.script;
        String signature1 = 'POST&'+encodedString+'&'+EncodingUtil.URLENCODE(signUrl,'UTF-8');
        String key = authDetails.customerSecret +'&'+ authDetails.tokenSecret;
        Blob hmacData = Crypto.generateMac('HMAC-SHA256', Blob.valueOf(signature1), Blob.valueOf(key));
        String signatureKey = EncodingUtil.base64Encode(hmacData);
        String finalGeneratedSignature = EncodingUtil.URLENCODE(signatureKey,'UTF-8');
        return finalGeneratedSignature;
    }

    public class Oauth1Wrapper{
        public String token;
        public String tokenSecret;
        public String customerKey;
        public String customerSecret;
        public String realm;
        public String signMethod;
        public String endPointUrl;
        public String script;
        public String timeStamp;
        public String nonce;
        public Oauth1Wrapper(NS_Sandboxes__c sandboxDet){
            //NSConnectorOauth1_0Config__mdt config = NSConnectorOauth1_0Config__mdt.getInstance(sandboxDet.Id);
            Map<String,NSConnectorOauth1Config__c> configMap = new Map<String,NSConnectorOauth1Config__c>();
            configMap = NSConnectorOauth1Config__c.getall();
            NSConnectorOauth1Config__c config = configMap.get(sandboxDet.Id);
            String scriptURL = sandboxDet.NS_Sync_Scripts__r.size() > 0 ? sandboxDet.NS_Sync_Scripts__r[0].Script_URL__c : null;
            this.token = config.Token__c;
            this.tokenSecret = config.Token_Secret__c;
            this.customerKey = config.Customer_Key__c;
            this.customerSecret = config.Customer_Secret__c;
            this.realm = sandboxDet.Realm__c;
            this.signMethod = sandboxDet.Signature_Method__c;
            this.endPointUrl = sandboxDet.End_Point_URL__c;
            If(scriptURL != null){
                this.script = scriptURL.substring(scriptURL.indexOf('?')+1,scriptURL.indexOf('&'));
            }
            this.timeStamp = String.valueOf(DateTime.now().getTime()/1000);
            this.nonce = String.valueOf(Crypto.getRandomLong());
        }

    }
}