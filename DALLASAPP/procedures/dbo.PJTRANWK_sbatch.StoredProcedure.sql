USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJTRANWK_sbatch]    Script Date: 12/21/2015 13:45:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJTRANWK_sbatch] @parm1 varchar (6), @parm2 varchar (2) , @parm3 varchar (10) as
select distinct batch_id, batch_type
from PJTRANWK
where fiscalno = @parm1 and
system_cd = @parm2 and
batch_id like @parm3
order by batch_id
GO
