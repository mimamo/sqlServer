USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARAutoPost]    Script Date: 12/21/2015 13:44:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ARAutoPost] @parm1 Varchar(21), @parm2 varchar (6) as

Select w.* from wrkrelease w, batch b
where w.batnbr = b.batnbr and w.module = "AR" and b.module = "AR"
and w.useraddress = @parm1 and b.status = "U" and b.perpost <= @parm2
GO
