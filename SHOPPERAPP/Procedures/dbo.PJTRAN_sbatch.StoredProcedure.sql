USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRAN_sbatch]    Script Date: 12/21/2015 16:13:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRAN_sbatch] @parm1 varchar (6) , @parm2 varchar (2) , @parm3 varchar (10) as
select * from PJTRAN
where fiscalno       = @parm1  and
          system_cd  = @parm2  and
          batch_id      = @parm3
GO
