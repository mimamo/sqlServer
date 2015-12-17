USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVHDR_Spk0]    Script Date: 12/16/2015 15:55:28 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVHDR_Spk0] @parm1 varchar (16) , @parm2 varchar (4)  as
SELECT  *    from PJREVHDR
WHERE       project = @parm1 and
revid = @parm2
	ORDER BY  project,revid
GO
