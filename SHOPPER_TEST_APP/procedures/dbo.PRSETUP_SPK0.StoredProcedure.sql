USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PRSETUP_SPK0]    Script Date: 12/21/2015 16:07:17 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PRSETUP_SPK0] as
select * from PRSETUP
where    setupid = 'PR'
order by setupid
GO
