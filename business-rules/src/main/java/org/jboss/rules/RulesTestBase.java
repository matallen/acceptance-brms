package org.jboss.rules;

import java.io.IOException;

import org.drools.KnowledgeBase;
import org.drools.KnowledgeBaseFactory;
import org.drools.event.rule.WorkingMemoryEventListener;
import org.drools.runtime.StatefulKnowledgeSession;

public class RulesTestBase {
	private StatefulKnowledgeSession session;
	public static final String ruleDirectoryDefault="src/main/resources/rules";
	
	public String getRuleDirectory(){ return ruleDirectoryDefault; }
	
	public StatefulKnowledgeSession loadRules(String packageName, String version) {
		try {
			RulePackageDownloader downloader=new RulePackageDownloader(getRuleDirectory(), "", "");
			KnowledgeBase kb=KnowledgeBaseFactory.newKnowledgeBase();
			kb.addKnowledgePackages(downloader.download(packageName, version));
			StatefulKnowledgeSession session=kb.newStatefulKnowledgeSession();
			this.session=session;
			return session;
		} catch (Exception e) {
			throw new RuntimeException("Unable to compile rules - more details in cause:", e);
		}
	}
	
	public <T> void fireAllRules(T... facts ){
//		EventListener listener=new EventListener();
		try{
//			session.addEventListener((WorkingMemoryEventListener)listener);
			for(T fact:facts)
				session.insert(fact);
			session.fireAllRules();
//			session.removeEventListener((WorkingMemoryEventListener)listener);
		}finally{
			session.dispose();
		}
	}
}
