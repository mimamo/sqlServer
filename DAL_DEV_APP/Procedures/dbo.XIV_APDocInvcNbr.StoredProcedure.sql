USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XIV_APDocInvcNbr]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XIV_APDocInvcNbr]
@parm1 smallint,
@parm2 varchar (15)
AS
select * from apdoc where Rlsed >= @parm1 and InvcNbr like @parm2 and invcnbr > '' order by invcnbr
GO
