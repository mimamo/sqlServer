USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJREVTSK_sTask]    Script Date: 12/21/2015 15:43:03 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJREVTSK_sTask] @parm1 varchar (16) , @parm2 varchar (32)   as
SELECT  *    from PJREVTSK T, PJREVHDR H
WHERE      T.project = @PARM1 AND
           T.pjt_entity = @parm2 and
T.project = H.project and
T.Revid = H.revid and
H.Status <> 'P'
ORDER BY       t.lupd_datetime DESC
GO
