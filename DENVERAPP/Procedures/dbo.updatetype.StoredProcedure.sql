USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[updatetype]    Script Date: 12/21/2015 15:43:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[updatetype] @parm1 varchar (8), @parm2 smallint as
select count (*) from kc21chg where 
keyid = @parm1 and
global = @parm2
GO
