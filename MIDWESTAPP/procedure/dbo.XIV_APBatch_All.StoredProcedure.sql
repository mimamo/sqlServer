USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[XIV_APBatch_All]    Script Date: 12/21/2015 15:55:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XIV_APBatch_All]
@parm1 varchar (10)
AS
select * from batch 
where module = 'AP' and batnbr like @parm1 and status <> 'V' 
order by module, batnbr
GO
