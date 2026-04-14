## This project is a work-in-progress 🛠️

**Completion status:**    🟩🟩🟩🟩🟩🟩🟩🟩🟩◻️    **90%**

### Overview

This project is based on the [**SQL Data Warehouse from Scratch**](https://www.youtube.com/watch?v=9GVqKuTVANE&list=PLNcg_FV9n7qaUWeyUkPfiVtMbKlrfMqA8&index=1) tutorial by **Data with Baraa**.

The goal: to explore data warehouse design and dimensional modelling—hands-on—using SQL Server. While this project leans into the responsibilities of a **data architect**, it’s a valuable learning experience with me wanting to grow my architectural literacy and end-to-end design fluency.

---

### Key Learnings

- **Medallion Architecture**  
  - **Bronze**: Raw data staged from CSV sources  
  - **Silver**: Cleaning and transforming  
  - **Gold**: Modelled for analytics using star schema  

- **Dimensional Modelling**  
  Designing dimension tables (e.g. `dim_customer`, `dim_product`) and a `fact_sales` table.  
  Re-learning the key differences between OLTP vs OLAP systems.

- **ETL Processes in SQL**  
  Creating stored procedures and layered SQL scripts to automate extract → transform → load.

- **Documentation & Transparency**  
  Maintained data flow diagrams, schema files, and layer-by-layer commentary.

---

### Architect vs Engineer: A Learning Stretch

As noted from my industry mentors, this project involves tasks and decisions typically handled by a **data architect**, not a junior engineer:

| Architect-Led Areas | Typical Engineering Responsibility |
|---------------------|-------------------------------------|
| <ul><li>Designing medallion architecture</li><li>Establishing naming & governance</li><li>Modelling dimensions & fact tables</li></ul> | <ul><li>Writing ETL queries within a defined schema</li><li>Loading data into staging or reporting layers</li><li>Maintaining and debugging transformation logic</li></ul> |


That said—**this stretch is the point**. I wanted to take on the challenge and widen my awareness.

Even if it’s above my current scope, this project helps me:

- Understand architectural patterns from the inside  
- Improve my Git + SQL workflow organisation  
- Build confidence documenting and explaining design rationale  

---

### A Note on My Notes

This repo includes a **notebook** which captures my **thinking-in-progress**. You may notice that:

- Some content feels repetitive or copied from course material  
- Certain lines read like personal reminders or incomplete thoughts  
- There are raw sections documenting early-stage learning

That’s intentional. These notes reflect how I’m internalising key concepts and building mental models—not polished documentation.

Thank you very much for your time! 😊🤙