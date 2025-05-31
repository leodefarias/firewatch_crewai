from crewai import Crew, Process
from crewai.config import Config
from crewai.loader import AgentLoader, TaskLoader

def montar_crew():
    # Carrega agentes e tarefas dos arquivos YAML
    agents = AgentLoader(path='crewai/config/agents.yaml').load()
    tasks = TaskLoader(path='crewai/config/tasks.yaml').load()

    # Monta a Crew com processo sequencial
    crew = Crew(
        agents=list(agents.values()),
        tasks=list(tasks.values()),
        process=Process.sequential,
        verbose=True
    )

    return crew
