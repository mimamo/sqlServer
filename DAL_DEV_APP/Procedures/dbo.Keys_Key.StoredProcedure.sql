USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Keys_Key]    Script Date: 12/21/2015 13:35:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Keys_Key] @parm1 varchar (8) as
SELECT * FROM Keys where 
	keyid = @parm1 and
	UpdSeq = '000'
        order by Keyid, UpdSeq
GO
