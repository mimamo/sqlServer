USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xkctask_Descr]    Script Date: 12/21/2015 13:36:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkctask_Descr]  as
update xkctask set fromdescr = P.pjt_entity_desc
from xkctask X
join pjpent P on x.project = P.project  and x.fromkey = P.pjt_entity
update xkctask set todescr  =  P.pjt_entity_desc
from xkctask X
join pjpent P on x.project = P.project and x.tokey= P.pjt_entity
GO
