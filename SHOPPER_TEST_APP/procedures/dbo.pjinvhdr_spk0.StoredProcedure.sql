USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjinvhdr_spk0]    Script Date: 12/21/2015 16:07:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjinvhdr_spk0] @parm1 varchar (10)  as
select * from pjinvhdr where draft_num = @parm1
order by draft_num
GO
