USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPAYHDR_Sbatref]    Script Date: 12/16/2015 15:55:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPAYHDR_Sbatref]  @parm1 varchar (10) , @parm2 varchar (10)   as
select * from PJPAYHDR
where
PJPAYHDR.batnbr       =    @parm1 and
PJPAYHDR.refnbr   =    @parm2
order by PJPAYHDR.batnbr, PJPAYHDR.refnbr
GO
