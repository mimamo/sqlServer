USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[AcctSub_Table_exist]    Script Date: 12/21/2015 15:42:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AcctSub_Table_exist]   as
SELECT distinct (tablename ), sysdb FROM acctsubKeys
order by tablename
GO
