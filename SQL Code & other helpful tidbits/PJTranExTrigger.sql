-- The trigger to populate the USER 2 field so that the billed to date collumn works properly on IGOR

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[xtrg_CopyRecordKeysToPJTRAN]
ON [dbo].[PJTRANEX] AFTER INSERT, UPDATE

AS

update pjtran set tr_id23=i.tr_id11, user2=i.tr_id12
from pjtran t, inserted i 
where
t.batch_id=i.batch_id 
and t.detail_num=i.detail_num 
and t.fiscalno=i.fiscalno 
and t.system_cd=i.system_cd


