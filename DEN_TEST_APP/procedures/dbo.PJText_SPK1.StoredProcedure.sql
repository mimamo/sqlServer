USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJText_SPK1]    Script Date: 12/21/2015 15:37:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJText_SPK1]  
	@msg_num varchar (4),
	@msg_text varchar (255) output
as

select @msg_text = msg_text from PJTEXT
where  msg_num  =  @msg_num
order by    msg_num
GO
