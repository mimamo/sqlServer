USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[XQMT2SCR_Get_Recs]    Script Date: 12/21/2015 13:45:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[XQMT2SCR_Get_Recs] 
@Parm1 char(6) 
as 
select * from XQMT2SCR where period like @Parm1 order by period desc
GO
