USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xkccpnyAcct_single]    Script Date: 12/21/2015 15:43:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xkccpnyAcct_single]  as
select * from xkccpnyAcct
where global <>1
order by fromkey, gridorder
GO
