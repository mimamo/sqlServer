USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkcWhseLoc_Descr]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkcWhseLoc_Descr]  as
update xkcwhseloc set fromdescr = l.descr
from xkcwhseloc X
join loctable L on x.siteid = l.siteid and x.fromkey = L.WhseLoc
update xkcwhseloc set todescr  = l.descr
from xkcwhseloc X
join loctable L on x.siteid = l.siteid and x.tokey= L.WhseLoc
GO
