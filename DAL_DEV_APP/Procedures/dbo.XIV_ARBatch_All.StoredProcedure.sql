USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XIV_ARBatch_All]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XIV_ARBatch_All] @parm1 varchar (10) AS 
select * from batch 
where module = 'AR' and batnbr like @parm1 and status <> 'V' 
order by module, batnbr
GO
