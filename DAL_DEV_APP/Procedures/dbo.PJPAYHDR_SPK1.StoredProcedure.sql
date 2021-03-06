USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPAYHDR_SPK1]    Script Date: 12/21/2015 13:35:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPAYHDR_SPK1]  @parm1 varchar (16) , @parm2 varchar (16) , @parm3 varchar (4)   as
select * from PJPAYHDR
where
PJPAYHDR.project       =    @parm1 and
PJPAYHDR.subcontract   =    @parm2 and
PJPAYHDR.payreqnbr    LIKE   @parm3
order by PJPAYHDR.project, PJPAYHDR.subcontract, PJPAYHDR.payreqnbr
GO
