USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSOHeader_OrdNbr_BOCntr]    Script Date: 12/21/2015 15:49:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDSOHeader_OrdNbr_BOCntr] @OrdNbr varchar(15), @CpnyID varchar(10) As
select * From EDSOHeader where ordnbr = @OrdNbr and cpnyid = @CpnyID order by ordnbr
GO
