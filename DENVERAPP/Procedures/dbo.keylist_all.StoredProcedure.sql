USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[keylist_all]    Script Date: 12/21/2015 15:42:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[keylist_all] @parm1 varchar (8) as
SELECT * from keylist where
keyid like @parm1
order by keyid
GO
