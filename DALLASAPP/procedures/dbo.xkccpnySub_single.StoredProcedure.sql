USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkccpnySub_single]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkccpnySub_single]  as
select * from xkccpnySub
where global <>1
order by fromkey,  gridorder
GO
