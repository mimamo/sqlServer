USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[keys_ALL]    Script Date: 12/21/2015 15:42:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[keys_ALL] @parm1 varchar (8) as	
SELECT * From Keys where keyid = @parm1 order by Keyid, UpdSeq
GO
