USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[XIV_Batch]    Script Date: 12/21/2015 16:01:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XIV_Batch]
@parm1 varchar (2),
@parm2 smallint,
@parm3 varchar (10)
AS
select * from batch 
where module like @parm1 and rlsed >= @parm2 and batnbr like @parm3 and status <> 'V' 
order by module, batnbr
GO
