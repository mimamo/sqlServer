USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvdet_spk4]    Script Date: 12/21/2015 16:07:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvdet_spk4] @parm1 varchar (10)  as
select * from PJINVDET
where pjinvdet.draft_num =      @parm1
order by pjinvdet.acct
GO
