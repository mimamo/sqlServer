USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDOC_spk1]    Script Date: 12/21/2015 14:05:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[APDOC_spk1] @parm1 varchar (10) , @parm2 varchar (10)   as
select * from APDOC
where batnbr = @parm1
and refnbr = @parm2
order by batnbr, refnbr
GO
