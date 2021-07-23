///////////////////////////////////////////////////////////////////////////
// (c) Copyright 2013 Cadence Design Systems, Inc. All Rights Reserved.
//
// File name   : counter.sv
// Title       : Class Polymorphism and Virtual Methods
// Project     : SystemVerilog Training
// Created     : 2013-4-8
// Description : Simple counter class
// Notes       :
// 
///////////////////////////////////////////////////////////////////////////

module counterclass;

// Parent count class 

 virtual class counter;
	// Class properties
	int count;
	int max, min;
	
	//Class Methods
	
	task load(input int c);
		check_set(c);
	endtask
	
	function int getcount();
		return count;
	endfunction
	
	//Explicit class constructor with argument
	function new(input int n, max_lim, min_lim);
		count = n;
		max = max_lim;
		min = min_lim;
		check_limit (max, min);
		check_set(count);
	endfunction
	
	//Check limit method
	task check_limit(input int a, b);
		if (a > b) 
		begin
			max = a;
			min = b;
		end
		else
		begin
			max = b;
			min = a;
		end
	endtask
	
	task check_set(input int set);
		if (set > max || set < min) begin
			count = min;
			$display("Warning: Set value is out off limit");
		end
		else
			count = set;
	endtask	

	virtual task next();
		$display("Inside Counter Class");
	endtask
endclass

class upcounter extends counter;
	bit carry = 0;
	static int frmcount;
	int up_tag;
	
	function new (input int upcount, up_limit, down_limit);
		super.new(upcount, up_limit, down_limit);
		frmcount++;
		up_tag = frmcount;
	endfunction
	
	task next();
      $display("Inside upcounter class");
      if (count <= max) 
        begin
          if (count == max) 
          	begin
				count = min;
				carry = 1;
              	//break;
			end
			else	
				carry = 0;
			count++;
		end
	endtask
	
	static function int getcount();
		return(frmcount);
	endfunction
endclass

class downcounter extends counter;
	bit borrow = 0;
	static int frmcount;
	int down_tag;
	
	function new (input int downcount, up_limit, down_limit);
		super.new(downcount, up_limit, down_limit);
		frmcount++;
		down_tag = frmcount;
	endfunction
	
	task next();
		while (count > min) begin
			$display("The decr count value:%d",count);
			count--;
		end
		if (count == min) begin
			count = max;
			borrow = 1;
			$display("The count:%d and borrow:%b value after roll under",count, borrow);
		end
		else
			borrow = 0;
	endtask
	
	static function int getcount();
		return(frmcount);
	endfunction
endclass

class timmer;
	upcounter hours;
	upcounter minutes;
	upcounter seconds;
	
	function new (input int hr, input int minu, input int sec);
		hours 	= 	new(hr, 23, 0);
		minutes = 	new(minu, 59, 0);
		seconds = 	new(sec, 59, 0);
	endfunction

	task load ( input int hr_count, min_count, sec_count);
		hours.count 	= hr_count;
		minutes.count 	= min_count;
		seconds.count 	= sec_count;
	endtask
	
	task showval();
		$display("%d : %d : %d", hours.count, minutes.count, seconds.count);
	endtask
		
	task next();
      while (!seconds.carry) begin
        	seconds.next();
        	showval();
        if (seconds.carry)
          begin
            minutes.next();
            seconds.carry = 0;
          end
        if (hours.carry)
          begin
            hours.next();
            minutes.carry = 0;
            seconds.carry = 0;
          end
      end
	endtask
         
endclass
  
  	// initial 
	// begin
		// timmer c1 = new(0, 0 , 0);
		// c1.load(1, 10 , 30);
      	// c1.next();
    // end
	
	counter c1;
  	upcounter u1 = new(0, 0, 0);
  	upcounter u2;
  
  	initial
  	begin
      c1 = u1;
      c1.next();
      $cast(u2,c1);
      u2.next();
    end
	
endmodule
