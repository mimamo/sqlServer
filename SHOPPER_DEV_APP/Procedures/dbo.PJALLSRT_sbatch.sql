USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJALLSRT_sbatch]    Script Date: 12/16/2015 15:55:26 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJALLSRT_sbatch]  @parm1 varchar (10)  as
select * from PJALLSRT
where alloc_batch = @parm1
GO
