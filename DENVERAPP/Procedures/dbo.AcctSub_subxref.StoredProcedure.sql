USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[AcctSub_subxref]    Script Date: 12/21/2015 15:42:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AcctSub_subxref]   @parm1 varchar (10), @parm2 varchar (24) as
SELECT * from subxref where
cpnyid = @parm1
and sub = @parm2
order by cpnyid, sub
GO
