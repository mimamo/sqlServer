USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xBatch_p1]    Script Date: 12/21/2015 14:06:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[xBatch_p1]
	@parm1 varchar(10)

as 

select
	* 
	from
		batch
	where
		cpnyid like @parm1 and
		Status in ('B','S') and
		module ='PA' and
		JrnlType = 'TFR'
GO
