USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Table_exist]    Script Date: 12/21/2015 14:06:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Table_exist] @parm1 varchar (8) as
SELECT distinct (tablename ),keyid, sysdb, specialrules FROM Keys where 
	keyid = @parm1 
	order by keyid
GO
