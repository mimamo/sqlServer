USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_spk4]    Script Date: 12/21/2015 16:01:08 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_spk4] @parm1 varchar (10)  as
select * from PJINVDET
where pjinvdet.draft_num =      @parm1
order by pjinvdet.acct
GO
