USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PJPAYHDR_sdupinv]    Script Date: 12/21/2015 16:01:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPAYHDR_sdupinv]  @parm1 varchar (15) , @parm2 varchar (15) , @parm3 varchar (4)   as
select * from PJPAYHDR, PJSUBCON
where
PJPAYHDR.project       =    PJSUBCON.project and
PJPAYHDR.subcontract   =   PJSUBCON.subcontract and
PJPAYHDR.vendor_invref = @parm1 and
PJSUBCON.vendid = @parm2 and
PJPAYHDR.payreqnbr <> @parm3
order by PJPAYHDR.project, PJPAYHDR.subcontract, PJPAYHDR.payreqnbr
GO
