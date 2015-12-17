USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xBatch_p1]    Script Date: 12/16/2015 15:55:37 ******/
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
