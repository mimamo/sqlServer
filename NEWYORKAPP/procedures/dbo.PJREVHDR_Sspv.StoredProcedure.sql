USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVHDR_Sspv]    Script Date: 12/21/2015 16:01:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVHDR_Sspv] @parm1 varchar (16) , @parm2 varchar (4)  as
SELECT  *    from PJREVHDR
WHERE       project like @parm1 and
revid Like @parm2
	ORDER BY  project,revid
GO
